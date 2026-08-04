import { loadConfig, PACKAGE_NAME, PACKAGE_VERSION } from "./core/config.js";
import { configureLogger, logDebug } from "./core/logger.js";
import { sanitizeUrl } from "./core/redact.js";
import { createApp } from "./http-app.js";

const config = loadConfig();
configureLogger({ debug: config.debug });
logDebug("config resolved", {
  trackUrl: sanitizeUrl(config.trackUrl),
  trackTokenSet: config.trackToken !== null,
  trackDisabled: config.trackDisabled,
  clientIdSet: config.clientId !== null,
  queuePath: config.queuePath,
  port: config.port,
});

const app = createApp(config);

app.listen(config.port, () => {
  logDebug(`HTTP listening on :${config.port}`, {
    name: PACKAGE_NAME,
    version: PACKAGE_VERSION,
  });
});
