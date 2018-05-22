<?php

namespace Tests\Feature;

use BDTheque\Models\User;
use Tests\TestCase;

class LoginTest extends TestCase
{
    /** @var \BDTheque\Models\User */
    protected $user;

    public function setUp()
    {
        parent::setUp();

        $this->user = factory(User::class)->create();
    }

    /** @test */
    function authenticate()
    {
        $this->postJson('/api/login', [
            'email' => $this->user->email,
            'password' => 'secret',
        ])
            ->assertSuccessful()
            ->assertJsonStructure(['token', 'expires_in'])
            ->assertJson(['token_type' => 'bearer']);
    }

    /** @test */
    function fetch_the_current_user()
    {
        $this->actingAs($this->user)
            ->getJson('/api/admin/user')
            ->assertSuccessful()
            ->assertJsonStructure(['id', 'name', 'email']);
    }

    /** @test */
    function log_out()
    {
        $token = $this->postJson('/api/login', [
            'email' => $this->user->email,
            'password' => 'secret',
        ])->json()['token'];

        $this->postJson("/api/admin/logout?token=$token")
            ->assertSuccessful();

        $this->getJson("/api/admin/user?token=$token")
            ->assertStatus(401);
    }
}
