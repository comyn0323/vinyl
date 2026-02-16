import { connect } from "node:http2";
import { SignJWT, importPKCS8 } from "jose";
import { apnsBundleId, apnsKeyId, apnsPrivateKey, apnsTeamId } from "../config";

const apnsHost = "https://api.push.apple.com";

export async function sendLiveActivityPush(token: string, payload: Record<string, unknown>): Promise<void> {
    const privateKey = await importPKCS8(apnsPrivateKey.value().replace(/\\n/g, "\n"), "ES256");
    const jwt = await new SignJWT({})
        .setProtectedHeader({ alg: "ES256", kid: apnsKeyId.value() })
        .setIssuer(apnsTeamId.value())
        .setIssuedAt()
        .sign(privateKey);

    const client = connect(apnsHost, { rejectUnauthorized: true });
    const apnsTopic = `${apnsBundleId.value()}.push-type.liveactivity`;

    const request = client.request({
        ":method": "POST",
        ":path": `/3/device/${token}`,
        authorization: `bearer ${jwt}`,
        "apns-topic": apnsTopic,
        "apns-push-type": "liveactivity",
        "apns-priority": "10"
    });

    request.setEncoding("utf8");
    request.write(JSON.stringify({
        aps: {
            timestamp: Math.floor(Date.now() / 1000),
            event: "update",
            "content-state": payload
        }
    }));
    request.end();

    await new Promise<void>((resolve, reject) => {
        request.on("response", (headers) => {
            const status = Number(headers[":status"] || 500);
            if (status >= 200 && status < 300) {
                resolve();
            } else {
                reject(new Error(`apns_error_${status}`));
            }
        });
        request.on("error", reject);
    }).finally(() => {
        client.close();
    });
}
