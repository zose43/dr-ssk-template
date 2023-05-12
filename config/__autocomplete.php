<?php

use yii\redis\Connection;
use yii\console\Application;

class Yii
{
    /**
     * @var \yii\web\Application|Application|__Application
     */
    public static Application|__Application|\yii\web\Application $app;
}

/**
 * @property Connection $redis
 */
class __Application
{
}
