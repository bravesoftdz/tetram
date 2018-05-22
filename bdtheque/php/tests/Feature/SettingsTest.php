<?php

namespace Tests\Feature;

use BDTheque\Models\User;
use Tests\TestCase;
use Illuminate\Support\Facades\Hash;

class SettingsTest extends TestCase
{
    /** @var User */
    protected $user;

    public function setUp()
    {
        parent::setUp();

        $this->user = factory(User::class)->create();
    }

    /** @test */
    public function update_profile_info()
    {
        $this->actingAs($this->user)
            ->patchJson('/api/admin/settings/profile', [
                'name' => 'Test User',
                'email' => 'test@test.app',
            ])
            ->assertSuccessful()
            ->assertJsonStructure(['id', 'name', 'email']);

        $this->assertDatabaseHas('users', [
            'id' => $this->user->id,
            'name' => 'Test User',
            'email' => 'test@test.app',
        ]);
    }

    /** @test */
    public function update_password()
    {
        $this->actingAs($this->user)
            ->patchJson('/api/admin/settings/password', [
                'password' => 'updated',
                'password_confirmation' => 'updated',
            ])
            ->assertSuccessful();

        $this->assertTrue(Hash::check('updated', $this->user->password));
    }
}
