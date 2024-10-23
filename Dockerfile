FROM node:22 AS dependencies

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm clean-install

FROM node:22 AS base
WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .

EXPOSE 3000

FROM base AS development

CMD ["npm", "run", "dev"]

FROM base AS build

RUN ["npm", "run", "build"]


FROM node:22 AS production

WORKDIR /app

COPY --from=build /app/.next ./.next
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./package.json
EXPOSE 3000
CMD ["npm", "run", "start"]