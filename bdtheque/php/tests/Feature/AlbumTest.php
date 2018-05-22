<?php

namespace Tests\Feature;


use BDTheque\Models\Album;
use BDTheque\Models\Editeur;
use BDTheque\Models\Serie;
use Tests\TestCase;

class AlbumTest extends TestCase
{
    /** @test */
    public function get_full_index()
    {
        factory(Editeur::class, 2)->create();
        factory(Serie::class, 3)->create();
        factory(Album::class, 15)->create();

        $data = $this->postJson('/api/albums/index')
            ->assertSuccessful()
            ->assertJsonStructure(['data'])
            ->decodeResponseJson('data');
        self::assertEquals(15, count($data));
    }

    /** @test */
    public function get_filtered_index()
    {
        factory(Editeur::class, 2)->create();
        factory(Serie::class, 3)->create();
        factory(Album::class, 15)->create();

        $this->postJson('/api/albums/index', ['filters' => ['column' => 'initiale_titre_album', 'operator' => '=', 'value' => '#']])
            ->assertSuccessful()
            ->assertJsonStructure(['data']);
    }
}