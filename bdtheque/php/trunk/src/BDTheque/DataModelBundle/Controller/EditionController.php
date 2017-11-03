<?php

namespace BDTheque\DataModelBundle\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use BDTheque\DataModelBundle\Entity\Edition;
use BDTheque\DataModelBundle\Form\Type\EditionType;

/**
 * Edition controller.
 *
 */
class EditionController extends Controller {

    /**
     * Lists all Edition entities.
     *
     */
    public function indexAction() {
        $em = $this->getDoctrine()->getManager();

        $entities = $em->getRepository('BDThequeDataModelBundle:Edition')->findAll();

        return $this->render('BDThequeDataModelBundle:Edition:index.html.twig', array(
                    'entities' => $entities,
                ));
    }

    /**
     * Finds and displays a Edition entity.
     *
     */
    public function showAction($id) {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Edition')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Edition entity.');
        }

        $deleteForm = $this->createDeleteForm($id);

        return $this->render('BDThequeDataModelBundle:Edition:show.html.twig', array(
                    'entity' => $entity,
                    'delete_form' => $deleteForm->createView(),));
    }

    /**
     * Displays a form to create a new Edition entity.
     *
     */
    public function newAction() {
        $entity = new Edition();
        $form = $this->createForm(new EditionType(), $entity);

        return $this->render('BDThequeDataModelBundle:Edition:new.html.twig', array(
                    'entity' => $entity,
                    'form' => $form->createView(),
                ));
    }

    /**
     * Creates a new Edition entity.
     *
     */
    public function createAction(Request $request) {
        $entity = new Edition();
        $form = $this->createForm(new EditionType(), $entity);
        $form->bind($request);

        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($entity);
            $em->flush();

            return $this->redirect($this->generateUrl('edition_show', array('id' => $entity->getId())));
        }

        return $this->render('BDThequeDataModelBundle:Edition:new.html.twig', array(
                    'entity' => $entity,
                    'form' => $form->createView(),
                ));
    }

    /**
     * Displays a form to edit an existing Edition entity.
     *
     */
    public function editAction($id) {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Edition')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Edition entity.');
        }

        $editForm = $this->createForm(new EditionType(), $entity);
        $deleteForm = $this->createDeleteForm($id);

        return $this->render('BDThequeDataModelBundle:Edition:edit.html.twig', array(
                    'entity' => $entity,
                    'edit_form' => $editForm->createView(),
                    'delete_form' => $deleteForm->createView(),
                ));
    }

    /**
     * Edits an existing Edition entity.
     *
     */
    public function updateAction(Request $request, $id) {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Edition')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Edition entity.');
        }

        $deleteForm = $this->createDeleteForm($id);
        $editForm = $this->createForm(new EditionType(), $entity);
        $editForm->bind($request);

        if ($editForm->isValid()) {
            $em->persist($entity);
            $em->flush();

            return $this->redirect($this->generateUrl('edition_edit', array('id' => $id)));
        }

        return $this->render('BDThequeDataModelBundle:Edition:edit.html.twig', array(
                    'entity' => $entity,
                    'edit_form' => $editForm->createView(),
                    'delete_form' => $deleteForm->createView(),
                ));
    }

    /**
     * Deletes a Edition entity.
     *
     */
    public function deleteAction(Request $request, $id) {
        $form = $this->createDeleteForm($id);
        $form->bind($request);

        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $entity = $em->getRepository('BDThequeDataModelBundle:Edition')->find($id);

            if (!$entity) {
                throw $this->createNotFoundException('Unable to find Edition entity.');
            }

            $em->remove($entity);
            $em->flush();
        }

        return $this->redirect($this->generateUrl('edition'));
    }

    private function createDeleteForm($id) {
        return $this->createFormBuilder(array('id' => $id))
                        ->add('id', 'hidden')
                        ->getForm()
        ;
    }

}

?>