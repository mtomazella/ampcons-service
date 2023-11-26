export const getUsers = async () => {
  return [
    {
      id: 'thisismia',
      name: 'Mia',
      sensorIds: ['0', '1', '2', '9C:9C:1F:CA:23:70'],
    },
  ]
}

export const getUser = async (id: string) => {
  return (await getUsers()).find(u => u.id === id) ?? null
}
