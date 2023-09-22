export const validateParameters = (
  data: Record<string, any>,
  requiredFields: string[],
) => {
  const missing: string[] = []

  requiredFields.forEach(field => {
    if (!(data ?? {})[field]) missing.push(field)
  })

  return {
    hasError: missing.length > 0,
    missing,
  }
}
