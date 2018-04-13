<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    const GENRE_COUNT = 10;

    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // $this->call(UsersTableSeeder::class);
        factory(\BDTheque\Models\User::class, 1)->states('admin')->create();
        factory(\BDTheque\Models\Genre::class, self::GENRE_COUNT)->create();
    }
}
