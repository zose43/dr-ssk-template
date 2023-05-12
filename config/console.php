<?php
declare(strict_types = 1);

use yii\redis\Cache;
use yii\redis\Connection;
use app\src\bootstrap\Bootstrapper;
use \yii\db\Connection as connectionDB;

$config = [
    'id' => 'test-kernel',
    'basePath' => dirname(__DIR__),
    'controllerNamespace' => 'app\src\commands',
    'aliases' => [
        '@tests' => '@app/tests',
    ],
    'bootstrap' => [
        Bootstrapper::class,
    ],
    'components' => [
        'db' => [
            'class' => connectionDB::class,
            'dsn' => getenv('DB'),
            'charset' => 'utf8',
            'enableLogging' => false,
            'enableProfiling' => false,
        ],
        'redis' => [
            'class' => Connection::class,
            'hostname' => getenv('REDIS_HOST'),
            'port' => getenv('REDIS_PORT') ?: 6379,
            'database' => getenv('REDIS_DB') ?: 0,
        ],
        'cache' => [
            'class' => Cache::class,
            'redis' => [
                'hostname' => getenv('REDIS_HOST'),
                'port' => getenv('REDIS_PORT') ?: 6379,
                'database' => getenv('REDIS_DB') ?: 1,
            ],
        ],
    ],
    'params' => [
        'rucaptcha_token' => getenv('RUCAPTCHA_TOKEN'),
    ],
];

return $config;
