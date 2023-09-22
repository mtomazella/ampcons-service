pub struct MeasurementQueryBuilder {
    sensor_id: String,
}

pub impl MeasurementQueryBuilder {
    pub fn use_sensor_id(self, sensor_id: String) -> MeasurementQueryBuilder {
        this.sensor_id = sensor_id;
        this
    }

    fn build_sensor_id(self) {}

    pub fn build(self) {}
}
