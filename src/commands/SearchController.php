<?php

namespace app\src\commands;

use yii\console\Controller;
use Yiisoft\Yii\Console\ExitCode;
use digitalreputationcorp\search_systems\models\SearchResultModel;
use digitalreputationcorp\search_systems\models\DTO\ParserTransferModel;

class SearchController extends Controller
{
    public function actionYandex(): int
    {
        $dto = new ParserTransferModel();
        $dto->system = SearchResultModel::YANDEX;
        $dto->searchQuery = '';     // add searchQuery

        $parser = $dto->getSearchParser();
        $parser->parseSearchResult();
        $parser->parseHtmlPages();

        return ExitCode::OK;
    }

    public function actionGoogle(): int
    {
        $dto = new ParserTransferModel();
        $dto->system = SearchResultModel::GOOGLE;
        $dto->searchQuery = '';     // add searchQuery

        $parser = $dto->getSearchParser();
        $parser->parseSearchResult();
        $parser->parseHtmlPages();

        return ExitCode::OK;
    }
}
