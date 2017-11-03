<?php

namespace BDTheque\DataModelBundle\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use BDTheque\DataModelBundle\Entity\Personne;
use BDTheque\DataModelBundle\Form\Type\PersonneType;

/**
 * Personne controller.
 *
 */
class PersonneController extends Controller {

    /**
     * Lists all Personne entities.
     *
     */
    public function indexAction() {
        $em = $this->getDoctrine()->getManager();

        $entities = $em->getRepository('BDThequeDataModelBundle:Personne')->findAll();

        return $this->render('BDThequeDataModelBundle:Personne:index.html.twig', array(
                    'entities' => $entities,
                ));
    }

    /**
     * Finds and displays a Personne entity.
     *
     */
    public function showAction($id) {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Personne')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Personne entity.');
        }

        $deleteForm = $this->createDeleteForm($id);

        return $this->render('BDThequeDataModelBundle:Personne:show.html.twig', array(
                    'entity' => $entity,
                    'delete_form' => $deleteForm->createView(),));
    }

    /**
     * Displays a form to create a new Personne entity.
     *
     */
    public function newAction() {
        $entity = new Personne();
        $form = $this->createForm(new PersonneType(), $entity);

        return $this->render('BDThequeDataModelBundle:Personne:new.html.twig', array(
                    'entity' => $entity,
                    'form' => $form->createView(),
                ));
    }

    /**
     * Creates a new Personne entity.
     *
     */
    public function createAction(Request $request) {
        $entity = new Personne();
        $form = $this->createForm(new PersonneType(), $entity);
        $form->bind($request);

        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($entity);
            $em->flush();

            return $this->redirect($this->generateUrl('personne_show', array('id' => $entity->getId())));
        }

        return $this->render('BDThequeDataModelBundle:Personne:new.html.twig', array(
                    'entity' => $entity,
                    'form' => $form->createView(),
                ));
    }

    /**
     * Displays a form to edit an existing Personne entity.
     *
     */
    public function editAction($id) {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Personne')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Personne entity.');
        }

        $editForm = $this->createForm(new PersonneType(), $entity);
        $deleteForm = $this->createDeleteForm($id);

        return $this->render('BDThequeDataModelBundle:Personne:edit.html.twig', array(
                    'entity' => $entity,
                    'edit_form' => $editForm->createView(),
                    'delete_form' => $deleteForm->createView(),
                ));
    }

    /**
     * Edits an existing Personne entity.
     *
     */
    public function updateAction(Request $request, $id) {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Personne')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Personne entity.');
        }

        $deleteForm = $this->createDeleteForm($id);
        $editForm = $this->createForm(new PersonneType(), $entity);
        $editForm->bind($request);

        if ($editForm->isValid()) {
            $em->persist($entity);
            $em->flush();

            return $this->redirect($this->generateUrl('personne_edit', array('id' => $id)));
        }

        return $this->render('BDThequeDataModelBundle:Personne:edit.html.twig', array(
                    'entity' => $entity,
                    'edit_form' => $editForm->createView(),
                    'delete_form' => $deleteForm->createView(),
                ));
    }

    /**
     * Deletes a Personne entity.
     *
     */
    public function deleteAction(Request $request, $id) {
        $form = $this->createDeleteForm($id);
        $form->bind($request);

        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $entity = $em->getRepository('BDThequeDataModelBundle:Personne')->find($id);

            if (!$entity) {
                throw $this->createNotFoundException('Unable to find Personne entity.');
            }

            $em->remove($entity);
            $em->flush();
        }

        return $this->redirect($this->generateUrl('personne'));
    }

    private function createDeleteForm($id) {
        return $this->createFormBuilder(array('id' => $id))
                        ->add('id', 'hidden')
                        ->getForm()
        ;
    }

}

?>