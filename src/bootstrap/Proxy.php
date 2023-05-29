<?php

declare(strict_types = 1);

namespace app\src\bootstrap;

use Yii;
use yii\redis\Cache;
use yii\helpers\Json;
use digitalreputationcorp\helpers\HttpClient;

final class Proxy extends Bootstrapper
{
    public function bootstrap($app): void
    {
        $token = getenv('WORK_YANDEX_DISK_TOKEN');
        $endpoint = getenv('WORK_YANDEX_ENDPOINT');
        if ($endpoint && $token) {
            $guzzle = new HttpClient([
                'headers' => [
                    'Authorization' => "OAuth $token"
                ]
            ]);
            $resp = $guzzle->client->get($endpoint);
            $url = Json::decode((string)$resp->getBody())['href'];
            $proxiesJson = file_get_contents($url);
        } else {
            /**
             * create proxy.json --> {"proxy": "https://user:pass@105.201.40.81:5555"}
             */
            $proxiesJson = file_get_contents(Yii::getAlias('@app/proxy.json'));
        }

        $proxies = Json::decode($proxiesJson);
        foreach ($proxies as $key => $proxy) {
            if ($key & 1) {
                $proxyKey = 'proxy:yandex';
            } else {
                $proxyKey = 'proxy:google';
            }
            (new Cache())->redis->rpush(
                $proxyKey,
                $proxy['proxy']
            );
        }
    }
}
