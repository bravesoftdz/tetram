<?php

namespace BDTheque\Providers;

use Doctrine\Common\Inflector\Inflector;
use Illuminate\Support\ServiceProvider;

class PluralizationServiceProvider extends ServiceProvider
{
    public function register()
    {
        Inflector::rules('singular', ['irregular' => [
            'albums' => 'album',
            'collections' => 'collection',
            'editeurs' => 'editeur',
            'editions' => 'edition',
            'genres' => 'genre',
            'imagesalbums' => 'imagealbum',
            'imagesparabds' => 'imageparabd',
            'parabds' => 'parabd',
            'personnes' => 'personne',
            'series' => 'serie',
            'univers' => 'univers',
            'users' => 'user'
        ]]);

        Inflector::rules('plural', ['irregular' => [
            'album' => 'albums',
            'collection' => 'collections',
            'editeur' => 'editeurs',
            'edition' => 'editions',
            'genre' => 'genres',
            'imagealbum' => 'imagesalbums',
            'imageparabd' => 'imagesparabds',
            'parabd' => 'parabds',
            'personne' => 'personnes',
            'serie' => 'series',
            'univers' => 'univers',
            'user' => 'users'
        ]]);
    }

}