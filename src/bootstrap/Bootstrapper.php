<?php

declare(strict_types = 1);

namespace app\src\bootstrap;

use yii\base\BootstrapInterface;

class Bootstrapper implements BootstrapInterface
{
    public function bootstrap($app): void
    {
        $bootstrappers = $this->classes();
        /** @var  $bootstrapper  Bootstrapper */
        foreach ($bootstrappers as $bootstrapper) {
            (new $bootstrapper())->bootstrap($app);
        }
    }

    protected function classes(): array
    {
        return [
            Proxy::class,
        ];
    }
}
