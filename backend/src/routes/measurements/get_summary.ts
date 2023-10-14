import { Request, Response } from 'express'
import { validateParameters } from '../../utils/validate_parameters'
import {
    BadRequest,
    InternalServerError,
    NoContent,
    Success,
} from '../../utils/response_builder'
import { buildMissingParamErrorString } from '../../utils/string_builders'
import { query } from '../../database/influx'
import {
    buildSummaryQuery,
} from '../../database/measurements'
import { isEmpty, omit } from 'lodash'

export const getSummary = async (request: Request, response: Response) => {
    try {
        const { hasError: hasErrorParams, missing: missingParams } =
            validateParameters(request.params, ['userId'])
        if (hasErrorParams)
            return BadRequest(response, buildMissingParamErrorString(missingParams))
        const { hasError, missing } = validateParameters(request.query, [])
        if (hasError)
            return BadRequest(response, buildMissingParamErrorString(missing))

        const { offset = '-1m' } = request.query

        const queryString = buildSummaryQuery({ timeOffset: offset.toString() })
        const queryResult = await query(queryString)

        const summaryResults = (queryResult as {result: string, [key: string]: any}[]).reduce((current, item) => ({ ...omit(item, ['table', 'result']), ...current }), {})
        if (isEmpty(summaryResults)) return NoContent(response)
            return Success(
                response,
                summaryResults,
                // queryResult as Record<string, any>[]
            )
    } catch (error) {
        return InternalServerError(response, error)
    }
}
