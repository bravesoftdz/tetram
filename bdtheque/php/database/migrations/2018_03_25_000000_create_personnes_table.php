<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePersonnesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('personnes', function (Blueprint $table) {
            $table->uuid('id')->charset('ascii')->nullable(false)->primary();

            $table->string('nom_personne', 150)->nullable(false);
            $table->char('initiale_nom_personne', 1)->charset('ascii')->nullable(false);
            $table->longText('biographie')->nullable(true);
            $table->string('site_web', 255)->nullable(true);

            $table->timestamps();
            $table->softDeletes();
        });

        Schema::table('personnes', function (Blueprint $table) {
            $table->unique('nom_personne');
            $table->index('initiale_nom_personne');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('personnes');
    }
}
