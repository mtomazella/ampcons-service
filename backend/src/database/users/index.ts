export const getUsers = async () => {
  return [
    {
      id: 'thisismia',
      name: 'Mia',
      sensorIds: ['0', '1', '2'],
    },
  ]
}

export const getUser = async (id: string) => {
  return (await getUsers()).find(u => u.id === id) ?? null
}
