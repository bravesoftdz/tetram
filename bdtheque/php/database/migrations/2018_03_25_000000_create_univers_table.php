<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUniversTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('univers', function (Blueprint $table) {
            $table->uuid('id')->charset('ascii')->nullable(false)->primary();

            $table->string('nom_univers', 150)->nullable(false);
            $table->char('initiale_nom_univers', 1)->charset('ascii')->nullable(false);
            $table->longText('description')->nullable(true);
            $table->string('site_web', 255)->nullable(true);

            $table->uuid('parent_univers_id')->charset('ascii')->nullable(true);
            $table->uuid('racine_univers_id')->charset('ascii')->nullable(true);
            $table->string('univers_branches', 2000)->charset('ascii')->nullable(true);

            $table->timestamps();
            $table->softDeletes();
        });

        Schema::table('univers', function (Blueprint $table) {
            $table->unique('nom_univers');
            $table->index('initiale_nom_univers');
            $table->index('parent_univers_id');
            $table->index('racine_univers_id');
            $table->unique('univers_branches');

            $table->foreign('parent_univers_id')->references('id')->on('univers')->onUpdate('cascade')->onDelete('cascade');
            $table->foreign('racine_univers_id')->references('id')->on('univers')->onUpdate('cascade')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('univers');
    }
}
