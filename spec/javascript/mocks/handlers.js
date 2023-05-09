import { rest } from 'msw';

export const handlers = [
   rest.post('/content_partners/1/transformation_definitions/1/fields', (req, res, ctx) => {
    return res(
      ctx.status(200),
      ctx.json({
        id: 3,
        name: 'Additional Field',
        block: '',
      })
    )
  }) 
]