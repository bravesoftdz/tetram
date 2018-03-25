<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateParaBdsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('para_bds', function (Blueprint $table) {
            $table->uuid('id')->charset('ascii')->nullable(false)->primary();

            $table->string('titre_para_bd', 150)->nullable(false);
            $table->string('initiale_titre_para_bd', 1)->charset('ascii')->nullable(false);
            $table->unsignedSmallInteger('categorie_para_bd')->nullable(true);
            $table->longText('description')->nullable(true);
            $table->longText('notes')->nullable(true);
            $table->date('date_achat')->nullable(true);
            $table->unsignedSmallInteger('annee')->nullable(true);
            $table->decimal('prix', 15, 2)->nullable(true);
            $table->boolean('dedicace')->nullable(true)->default(false);
            $table->boolean('numerote')->nullable(true)->default(false);
            $table->boolean('gratuit')->nullable(true)->default(false);
            $table->boolean('offert')->nullable(true)->default(false);

            $table->boolean('prevision_achat')->nullable(false)->default(false);
            $table->boolean('valide')->nullable(false)->default(true);

            $table->uuid('serie_id')->charset('ascii')->nullable(true);

            $table->timestamps();
            $table->softDeletes();
        });

        Schema::table('para_bds', function (Blueprint $table) {
            $table->unique('titre_para_bd');
            $table->index('initiale_titre_para_bd');
            $table->index('serie_id');

            $table->foreign('serie_id')->references('id')->on('series')->onUpdate('cascade')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('para_bds');
    }
}
