<template>
	<v-layout row>
		<v-flex xs12 sm8 offset-sm2 lg4 offset-lg4>
			<v-card>
				<progress-bar :show="busy"></progress-bar>
				<form @submit.prevent="login" @keydown="form.onKeydown($event)">
					<v-card-title primary-title>
						<h3 class="headline mb-0">Coonnexion</h3>
					</v-card-title>
					<v-card-text>

						<!-- Email -->
						<email-input
								:form="form"
								label='Adresse mail'
								:v-errors="errors"
								:value.sync="form.email"
								name="email"
								prepend="person_outline"
								v-validate="'required|email'"
						></email-input>

						<!-- Password -->
						<password-input
								:v-errors="errors"
								:form="form"
								:value.sync="form.password"
								prepend="lock_outline"
								v-validate="'required|min:6'"
						></password-input>

						<!-- Remember Me -->
						<v-checkbox
								label='Se souvenir de moi'
								color="primary"
								type="checkbox"
								v-model="remember"
								value="true"
						></v-checkbox>

						<submit-button :block="true" :form="form" label='Connexion'></submit-button>

					</v-card-text>
					<v-card-actions>
						<router-link :to="{ name: 'register' }">Connexion</router-link>
						<v-spacer></v-spacer>
						<router-link :to="{ name: 'password.request' }">Mot de passe oublié</router-link>
					</v-card-actions>
				</form>
			</v-card>
		</v-flex>
	</v-layout>
</template>

<script>
  import Form from 'vform'

  export default {
    name: 'login-view',
    metaInfo () {
      return {title: 'Connexion'}
    },
    data: () => ({
      form: new Form({
        email: '',
        password: ''
      }),
      eye: true,
      remember: false,
      busy: false
    }),

    methods: {
      async login () {
        if (await this.formHasErrors()) return
        this.busy = true
        try {
          // Submit the form.
          const {data} = await this.form.post('/api/login')

          // Save the token.
          this.$store.dispatch('saveToken', {
            token: data.token,
            remember: this.remember
          })

          // Fetch the user.
          await this.$store.dispatch('fetchUser')
        }
        finally {
          this.busy = false
        }

        // Redirect home.
        this.$router.push({name: 'home'})
      }
    }
  }
</script>
