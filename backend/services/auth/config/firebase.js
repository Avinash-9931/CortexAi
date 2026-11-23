import { initializeApp, cert, getApps } from "firebase-admin/app";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

let app = null;

try {
  let credential = null;

  if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    const raw = process.env.FIREBASE_SERVICE_ACCOUNT.trim();
    const jsonStr = raw.startsWith("{") ? raw : Buffer.from(raw, "base64").toString("utf-8");
    credential = cert(JSON.parse(jsonStr));
  } else {
    const keyPath = path.resolve(__dirname, "../serviceAccountKey.json");
    if (fs.existsSync(keyPath)) {
      const raw = fs.readFileSync(keyPath, "utf-8");
      credential = cert(JSON.parse(raw));
    }
  }

  if (credential) {
    app = getApps().length === 0 ? initializeApp({ credential }) : getApps()[0];
  } else {
    console.warn("⚠️ Firebase service account not provided. Set FIREBASE_SERVICE_ACCOUNT env var or add serviceAccountKey.json.");
  }
} catch (error) {
  console.error("Firebase admin initialization error:", error);
}

export { app };
