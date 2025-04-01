import pino from 'pino';

const logger = pino({
  transport: {
    target: 'pino-loki',
    options: {
      host: 'http://loki:3100',
      labels: { service: 'node-app', env: 'dev' },
    }
  }
});

export default logger;


// import pino from "pino";

// const logger = pino({
//   transport: {
//     target: "pino-pretty",
//     options: {
//       colorize: true,
//       translateTime: "HH:MM:ss",
//       ignore: "pid,hostname"
//     }
//   },
// });

// export default logger;