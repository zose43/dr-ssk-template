<?php

declare(strict_types = 1);

namespace app\src\commands;

use yii\console\ExitCode;
use yii\console\Controller;

final class WikiController extends Controller
{
    public function actionParse(): int
    {
        return ExitCode::OK;
    }
}
