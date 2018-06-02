<template>
	<v-card flat>
		<form @submit.prevent="update" @keydown="form.onKeydown($event)">
			<v-card-title primary-title>
				<h5 class="subheading mb-0">Mot de passee</h5>
			</v-card-title>
			<v-card-text>

				<!-- Password -->
				<password-input
						:form="form"
						hint="Le mot de passe doit contenir au moins 8 caractères"
						:v-errors="errors"
						:value.sync="form.password"
						v-on:eye="eye = $event"
						v-validate="'required|min:8'"
				></password-input>

				<!-- Password Confirmation -->
				<password-input
						:form="form"
						:hide="eye"
						label="Confirmation du mot de passe"
						:v-errors="errors"
						:value.sync="form.password_confirmation"
						data-vv-as="password"
						hide-icon="true"
						name="password_confirmation"
						v-validate="'required|confirmed:password'"
				></password-input>

				<!-- <form-feedback :form="form" text="Mot de passe modifié"></form-feedback> -->

			</v-card-text>
			<v-card-actions>
				<submit-button :flat="true" :form="form" label="Mettre à jour"></submit-button>
			</v-card-actions>
		</form>
	</v-card>
</template>

<script>
  import Form from 'vform'

  export default {
    name: 'password-view',
    data: () => ({
      form: new Form({
        password: '',
        password_confirmation: ''
      }),
      eye: true
    }),

    methods: {
      async update () {
        if (await this.formHasErrors()) return

        this.$emit('busy', true)

        await this.form.patch('/api/admin/settings/password')

        this.form.reset()
        this.$emit('busy', false)

        this.$store.dispatch('responseMessage', {
          type: 'success',
          text: 'Mot de passe modifié'
        })
      }
    }
  }
</script>
