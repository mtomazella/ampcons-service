export const autodefineAggregationInterval = ({
  offset = '-1d',
}: {
  offset: string
}): string => {
  const lowerOffset = offset.toLowerCase()
  if (lowerOffset.includes('y')) return '1m'
  if (lowerOffset.includes('mo')) return '1d'
  if (lowerOffset.includes('w')) return '1d'
  if (lowerOffset.includes('d')) return '1h'
  if (lowerOffset.includes('h')) return '1m'
  return '1s'
}
