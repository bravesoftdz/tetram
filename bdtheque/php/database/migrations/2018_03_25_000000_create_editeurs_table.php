<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateEditeursTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('editeurs', function (Blueprint $table) {
            $table->uuid('id')->charset('ascii')->nullable(false)->primary();

            $table->string('nom_editeur', 50)->nullable(false);
            $table->char('initiale_nom_editeur', 1)->charset('ascii')->nullable(false);
            $table->string('site_web', 255)->nullable(true);

            $table->timestamps();
            $table->softDeletes();
        });

        Schema::table('editeurs', function (Blueprint $table) {
            $table->unique('nom_editeur');
            $table->index('initiale_nom_editeur');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('editeurs');
    }
}
