#include <Arduino.h>
#include <Adafruit_ADS1X15.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <HTTPClient.h>

#define MOVING_AVG_SAMPLE_SIZE 200
#define ADS_CURRENT_CHANNEL 0
#define ADS_VOLTAGE_CHANNEL 1
#define CALIBRATION_TIME_MS 10000

const char *NETWORK_SSID = "AMPCONS";
const char *NETWORK_PASSWORD = "aaaaaaaa";
// const char *MEASUREMENTS_API_URL = "http://192.168.15.9:3001/measurements";

// const char *NETWORK_SSID = "M";
// const char *NETWORK_PASSWORD = "gamerule";
const char *MEASUREMENTS_API_URL = "http://192.168.0.10:3001/measurements";

float voltageMovAverageVector[MOVING_AVG_SAMPLE_SIZE];
int voltageMovAverageIndex = 0;
float currentMovAverageVector[MOVING_AVG_SAMPLE_SIZE];
int currentMovAverageIndex = 0;

float currentCalibrationConstant = 0;
float voltageCalibrationConstant = 0;

WiFiMulti wifiMulti;
Adafruit_ADS1115 ads;

struct DataPoint
{
  float tension;
  float current;
};
typedef struct DataPoint DataPoint;

float readSensor(int channel, float *vector, int *index, float calibrationConstant);
float readSensorRMS(int channel, float *vector, int *index, float calibrationConstant);
float getCalibrationConstant(int channel, float *vector, int *index, int calibrationTime);
DataPoint sampleDataPoint();
void postDataPoint(DataPoint data);
void printDataPoint(DataPoint data);

void setup(void)
{
  Serial.begin(19200);

  if (!ads.begin())
  {
    Serial.println("Failed to initialize ADS.");
    while (1)
      ;
  }

  wifiMulti.addAP(NETWORK_SSID, NETWORK_PASSWORD);

  Serial.println("Calibrating sensor 1");
  currentCalibrationConstant = getCalibrationConstant(ADS_CURRENT_CHANNEL, currentMovAverageVector, &currentMovAverageIndex, CALIBRATION_TIME_MS);
  Serial.printf("(%f)\n", currentCalibrationConstant);
  // Serial.println("Calibrating sensor 2");
  // voltageCalibrationConstant = getCalibrationConstant(ADS_VOLTAGE_CHANNEL, voltageMovAverageVector, &voltageMovAverageIndex, CALIBRATION_TIME_MS);
  // Serial.printf("(%f)\n", voltageCalibrationConstant);

  for (int i = 0; i < 200; i++)
    sampleDataPoint();

  Serial.println("Calibration complete");
}

void loop(void)
{
  DataPoint data = sampleDataPoint();
  printDataPoint(data);

  static int lastUpload = 0;
  if (millis() - lastUpload < 5000)
    return;

  postDataPoint(data);
  lastUpload = millis();
}

float readSensor(int channel, float *vector, int *index, float calibrationConstant)
{
  if (*index >= 2 * MOVING_AVG_SAMPLE_SIZE)
    *index = MOVING_AVG_SAMPLE_SIZE;
  int fullyInitialized = *index > MOVING_AVG_SAMPLE_SIZE;
  int actualIndex = fullyInitialized ? *index - MOVING_AVG_SAMPLE_SIZE : *index;

  float value = ads.readADC_SingleEnded(channel) - calibrationConstant;

  vector[actualIndex] = value;
  *index += 1;

  float sum = 0;
  for (int i = 0; i < (!fullyInitialized ? actualIndex + 1 : MOVING_AVG_SAMPLE_SIZE); i++)
    sum += vector[i];

  return sum / (!fullyInitialized ? actualIndex + 1 : MOVING_AVG_SAMPLE_SIZE);
}

float readSensorRMS(int channel, float *vector, int *index, float calibrationConstant)
{
  if (*index >= MOVING_AVG_SAMPLE_SIZE)
    *index = 0;
  if (*index < 0)
    *index = 0;

  float value = ads.readADC_SingleEnded(channel) - calibrationConstant;
  value = value * 169 / 14288;

  vector[*index] = value;
  *index += 1;

  float max = -100000;
  for (int i = 0; i < MOVING_AVG_SAMPLE_SIZE; i++)
    if (max < vector[i])
      max = vector[i];

  // Serial.printf("%f, %d, ", max, *index);
  return max * 0.707;
}

float getCalibrationConstant(int channel, float *vector, int *index, int calibrationTime)
{
  int initialTime = millis();

  float constant = 0;

  while (millis() - initialTime < calibrationTime)
    constant = readSensor(channel, vector, index, 0);

  return constant;
}

DataPoint sampleDataPoint()
{
  DataPoint data;
  float current = (readSensor(ADS_CURRENT_CHANNEL, currentMovAverageVector, &currentMovAverageIndex, currentCalibrationConstant)) * 0.0037623;
  float voltage = (readSensorRMS(ADS_VOLTAGE_CHANNEL, voltageMovAverageVector, &voltageMovAverageIndex, 0));
  data.current = current;
  data.tension = voltage;
  return data;
}

void postDataPoint(DataPoint data)
{
  if ((wifiMulti.run() == WL_CONNECTED))
  {
    HTTPClient http;
    http.begin(MEASUREMENTS_API_URL);
    http.addHeader("Content-Type", "application/json");
    char json[100];
    sprintf(json, "{\"tension\": %.4f, \"current\": %.4f, \"sensor_id\": \"9C:9C:1F:CA:23:70\"}", data.tension, data.current);
    Serial.println(json);
    int httpCode = http.POST(json);

    if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_CREATED)
    {
      String payload = http.getString();
      Serial.println(payload);
      Serial.println();
    }
    else
    {
      Serial.printf("[HTTP] POST... failed, error: %d %s\n\n", httpCode, http.errorToString(httpCode).c_str());
    }

    http.end();
  }
  else
    Serial.println("[HTTP] Connection Error");
}

void printDataPoint(DataPoint data)
{
  // Serial.println(data.tension);
  // Serial.println(data.current);
  Serial.printf("%f, %f\n", data.tension, data.current);
}