<?php

namespace app\src\commands;

use Yii;
use yii\console\Controller;
use Yiisoft\Yii\Console\ExitCode;
use digitalreputationcorp\search_systems\SearchSiteParsable;
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
        $this->setHTML($parser, $dto);

        return ExitCode::OK;
    }

    public function actionGoogle(): int
    {
        $dto = new ParserTransferModel();
        $dto->system = SearchResultModel::GOOGLE;
        $dto->searchQuery = '';     // add searchQuery

        $parser = $dto->getSearchParser();
        $this->setHTML($parser, $dto);

        return ExitCode::OK;
    }

    private function setHTML(SearchSiteParsable $parser, ParserTransferModel $dto): void
    {
        $pages = Yii::$app->cache
            ->getOrSet($dto->country . $dto->system . $dto->searchQuery, function () use ($parser) {
                $parser->parseSearchResult();
                if ($result = $parser->getSearchHtml()) {
                    return $result;
                }
                return false;
            }, 60 * 60 * 4);

        $parser->setSearchHtml($pages);
    }
}
