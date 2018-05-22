<?php

use BDTheque\Models\Album;
use BDTheque\Models\Collection;
use BDTheque\Models\Editeur;
use BDTheque\Models\Genre;
use BDTheque\Models\Personne;
use BDTheque\Models\Serie;
use BDTheque\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    const FACTOR = 20;
    const GENRE_COUNT = 10;

    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // $this->call(UsersTableSeeder::class);
        factory(User::class, 1)->states('admin')->create();
        factory(Genre::class, self::GENRE_COUNT)->create();
        factory(Editeur::class, 2.5 * self::FACTOR)->create();
        factory(Collection::class, 2 * 2.5 * self::FACTOR)->create();
        factory(Personne::class, 50 * self::FACTOR)->create();
        factory(Serie::class, 15 * self::FACTOR)->create();
        factory(Album::class, 100 * self::FACTOR)->create();
    }
}
