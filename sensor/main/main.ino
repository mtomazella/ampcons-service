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

// SENSOR
const int   READINGS_PER_DATA_POINT = 10;
const int   MS_BETWEEN_DATA_POINTS  = 50;
const float AMPS_PER_ANALOG_POINT   = 0.00137844612;
const float ERROR_COMPENSATION      = 125.94;

void setup() {
    Serial.begin(115200);
    wifiMulti.addAP(NETWORK_SSID, NETWORK_PASSWORD);
}

float getCorrectedSample () {
  float reading = (float) analogRead(AMP_SENSOR_PIN);
  if (reading == 0) return 0;
  return reading + ERROR_COMPENSATION;
}

float sampleDataPoint () {
  float total = 0;
  for (int i = 0; i < READINGS_PER_DATA_POINT; i++) {
    total += getCorrectedSample();
    delay(MS_BETWEEN_DATA_POINTS);
  }
  return (float) total / (float) READINGS_PER_DATA_POINT * AMPS_PER_ANALOG_POINT;
}

void postDataPoint (float measurement) {
  if((wifiMulti.run() == WL_CONNECTED)) {
    HTTPClient http;
    http.begin(MEASUREMENTS_API_URL);
    http.addHeader("Content-Type", "application/json");
    char json[100];
    sprintf(json, "{\"tension\": 220, \"current\": %f, \"comp_id\": \"1\"}", measurement);
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

void loop() {
  float current = sampleDataPoint();
  Serial.println(current);
  postDataPoint(current);
}
