<?php

declare(strict_types = 1);

namespace app\src\bootstrap;

use Yii;
use yii\redis\Cache;
use yii\helpers\Json;

final class Proxy extends Bootstrapper
{
    public function bootstrap($app): void
    {
        // TODO get proxy from s3 or another cloud
        $proxiesJson = file_get_contents(Yii::getAlias('@app/proxy.json'));
        $proxies = Json::decode($proxiesJson);
        foreach ($proxies as $key=> $proxy) {
            if ($key&1) {
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
