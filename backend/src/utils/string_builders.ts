export const buildMissingParamErrorString = (missingData: string[]) => {
  return `Missing required parameters: ${missingData
    .slice(0, missingData.length > 1 ? missingData.length - 1 : undefined)
    .join(', ')}${missingData.length > 1 ? ` and ${missingData.at(-1)}` : ''}`
}
