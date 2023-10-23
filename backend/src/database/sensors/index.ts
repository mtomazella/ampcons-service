export const getSensors = async () => {
  return {
    0: {
      id: '0',
      name: 'Sensor 1',
    },
    1: {
      id: '1',
      name: 'Sensor 2',
    },
    2: {
      id: '2',
      name: 'Sensor 3',
    },
    3: {
      id: '3',
      name: 'Sensor 4',
    },
    4: {
      id: '4',
      name: 'Sensor 5',
    },
    5: {
      id: '5',
      name: 'Sensor 6',
    },
    6: {
      id: '6',
      name: 'Sensor 7',
    },
    7: {
      id: '7',
      name: 'Sensor 8',
    },
    8: {
      id: '8',
      name: 'Sensor 9',
    },
    9: {
      id: '9',
      name: 'Sensor 10',
    },
    10: {
      id: '10',
      name: 'Sensor 11',
    },
    11: {
      id: '11',
      name: 'Sensor 12',
    },
    12: {
      id: '12',
      name: 'Sensor 13',
    },
    13: {
      id: '13',
      name: 'Sensor 14',
    },
    14: {
      id: '14',
      name: 'Sensor 15',
    },
  }
}

export const getSensorList = async (sensorIds: string[]) => {
  const sensors = (await getSensors()) as Record<string, any>
  return sensorIds.map(id => sensors[id])
}
