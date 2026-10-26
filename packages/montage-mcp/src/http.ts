import { loadConfig, PACKAGE_NAME, PACKAGE_VERSION } from "./core/config.js";
import { startRemoteDataRefresher } from "./core/data/remote.js";
import { configureLogger, logDebug, logError, logInfo } from "./core/logger.js";
import { sanitizeUrl } from "./core/redact.js";
import { createApp } from "./http-app.js";
import { createGoogleAuth, loadAuthConfig, type HttpAuth } from "./http-auth.js";

const config = loadConfig();
configureLogger({ debug: config.debug });

// Auth is opt-in; a misconfigured MONTAGE_MCP_AUTH must stop the boot rather
// than expose the server unauthenticated.
let auth: HttpAuth | undefined;
try {
  const authConfig = loadAuthConfig();
  auth = authConfig ? await createGoogleAuth(authConfig) : undefined;
} catch (err) {
  logError("auth setup failed", err);
  process.exit(1);
}

logDebug("config resolved", {
  trackUrl: sanitizeUrl(config.trackUrl),
  trackTokenSet: config.trackToken !== null,
  trackDisabled: config.trackDisabled,
  clientIdSet: config.clientId !== null,
  queuePath: config.queuePath,
  port: config.port,
  dataUrl: sanitizeUrl(config.dataUrl),
  dataRefreshSec: config.dataRefreshSec,
  auth: auth ? "google" : "off",
});

logInfo("startup", {
  transport: "http",
  auth: auth ? "google" : "off",
  remoteData: config.dataRefreshSec > 0 ? "on" : "off",
  ...(config.dataRefreshSec > 0
    ? { dataUrl: sanitizeUrl(config.dataUrl), dataRefreshSec: config.dataRefreshSec }
    : {}),
});

startRemoteDataRefresher(config);

const app = createApp(config, auth ? { auth } : {});

app.listen(config.port, () => {
  logDebug(`HTTP listening on :${config.port}`, {
    name: PACKAGE_NAME,
    version: PACKAGE_VERSION,
  });
});
