#include <Arduino.h>
#include <stdio.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <HTTPClient.h>

WiFiMulti wifiMulti;

// HARDWARE
const int   AMP_SENSOR_PIN          = 34;

// WIFI
const char* NETWORK_SSID            = "A";
const char* NETWORK_PASSWORD        = "A216191310";
const char* MEASUREMENTS_API_URL    = "http://192.168.15.7:3001/measurement";

// SENSORS
const int   READINGS_PER_DATA_POINT     = 10;
const int   MS_BETWEEN_SAMPLES          = 50;
  // CURRENT
const float AMPS_PER_ANALOG_POINT       = 0.00137844612;
const float CURRENT_ERROR_COMPENSATION  = 125.94;
  // TENSION
const float VOLTS_PER_ANALOG_POINT      = 1;
const float TENSION_ERROR_COMPENSATION  = 0;

struct DataPoint {
  float tension;
  float current;
};
typedef struct DataPoint DataPoint;

void setup() {
    Serial.begin(115200);
    wifiMulti.addAP(NETWORK_SSID, NETWORK_PASSWORD);
}

float getMockSample (float baseline, float maxVariation) {
  return baseline + random(-maxVariation, maxVariation) + random(100) / 100;
}

float getCorrectedSample (int pin, float correction) {
  float reading = (float) analogRead(pin);
  if (reading == 0) return 0;
  return reading + correction;
}

DataPoint sampleDataPoint () {
  DataPoint data;
  for (int i = 0; i < READINGS_PER_DATA_POINT; i++) {
    data.current += getCorrectedSample(AMP_SENSOR_PIN, CURRENT_ERROR_COMPENSATION);
    data.tension += getMockSample(127, 20);
    delay(MS_BETWEEN_SAMPLES);
  }
  data.current = data.current / (float) READINGS_PER_DATA_POINT * AMPS_PER_ANALOG_POINT;
  data.tension = data.tension / (float) READINGS_PER_DATA_POINT * VOLTS_PER_ANALOG_POINT;
  return data;
}

void postDataPoint (DataPoint data) {
  if((wifiMulti.run() == WL_CONNECTED)) {
    HTTPClient http;
    http.begin(MEASUREMENTS_API_URL);
    http.addHeader("Content-Type", "application/json");
    char json[100];
    sprintf(json, "{\"tension\": %f, \"current\": %f, \"comp_id\": \"1\"}", data.tension, data.current);
    int httpCode = http.POST(json);

    if(httpCode > 0 && httpCode == HTTP_CODE_OK) {  
      String payload = http.getString();
      Serial.println(payload);
      Serial.println();
    } else {
      Serial.printf("[HTTP] POST... failed, error: %s\n\n", http.errorToString(httpCode).c_str());
    }

    http.end();
  } else Serial.println("[HTTP] Connection Error");
}

void printDataPoint (DataPoint data) {
  Serial.printf("Tension: %fV; Current: %fA\n", data.tension, data.current);
}

void loop() {
  DataPoint data = sampleDataPoint();
  printDataPoint(data);
  postDataPoint(data);
}
