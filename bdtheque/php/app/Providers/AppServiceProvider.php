<?php

namespace BDTheque\Providers;

use Illuminate\Database\Events\QueryExecuted;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        DB::listen(function (QueryExecuted $query) {
            if ($query->sql) {
                Log::debug("\n" .
                    $query->sql .
                    ($query->bindings ? "\nParams: " . var_export($query->bindings, true) : '') .
                    "\nRuntime: $query->time"
                );
            }
        });
    }

    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }
}
