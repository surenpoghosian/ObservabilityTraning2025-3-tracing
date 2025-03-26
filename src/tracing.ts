import { NodeSDK } from '@opentelemetry/sdk-node';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-http';
import { diag, DiagConsoleLogger, DiagLogLevel } from '@opentelemetry/api';

diag.setLogger(new DiagConsoleLogger(), DiagLogLevel.INFO);

const serviceName = 'observability-tracing'

const traceExporter = new OTLPTraceExporter({
  url: 'http://jaeger:4318/v1/traces',
});

const sdk = new NodeSDK({
  serviceName,
  traceExporter,
  instrumentations: [getNodeAutoInstrumentations()],
});

sdk.start()
