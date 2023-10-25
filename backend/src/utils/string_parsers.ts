import { StringList } from '../types/requests'

export const parseStringList = (list: StringList | undefined) => {
  if (!list) return []
  return list.split(',').map(e => e.trim())
}
