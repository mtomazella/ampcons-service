import { Response } from 'express'

type ResponseBody = Record<string, any>

const buildResponse = (
  response: Response,
  { status, json }: { status: number; json: ResponseBody },
) => {
  response.statusCode = status ?? 500
  if (json) response.json(json)

  return response
}

export const Success = (response: Response, data: ResponseBody) => {
  return buildResponse(response, { status: 200, json: data })
}

export const Created = (response: Response, data: ResponseBody) => {
  return buildResponse(response, { status: 201, json: data })
}

export const BadRequest = (response: Response, message?: string) => {
  return buildResponse(response, {
    status: 400,
    json: { message: message ?? 'Request parameters were invalid' },
  })
}

export const InternalServerError = (response: Response, error?: any) => {
  return buildResponse(response, {
    status: 400,
    json: error ?? { message: 'An unknown error occurred' },
  })
}
