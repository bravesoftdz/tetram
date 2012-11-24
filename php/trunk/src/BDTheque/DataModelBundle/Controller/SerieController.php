<?php

namespace BDTheque\DataModelBundle\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use BDTheque\DataModelBundle\Entity\Serie;
use BDTheque\DataModelBundle\Form\SerieType;

/**
 * Serie controller.
 *
 */
class SerieController extends Controller {

    /**
     * Lists all Serie entities.
     *
     */
    public function indexAction() {
        $em = $this->getDoctrine()->getManager();

        $entities = $em->getRepository('BDThequeDataModelBundle:Serie')->findAll();

        return $this->render('BDThequeDataModelBundle:Serie:index.html.twig', array(
                    'entities' => $entities,
                ));
    }

    /**
     * Finds and displays a Serie entity.
     *
     */
    public function showAction($id) {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Serie')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Serie entity.');
        }

        $deleteForm = $this->createDeleteForm($id);

        return $this->render('BDThequeDataModelBundle:Serie:show.html.twig', array(
                    'entity' => $entity,
                    'delete_form' => $deleteForm->createView(),));
    }

    /**
     * Displays a form to create a new Serie entity.
     *
     */
    public function newAction() {
        $entity = new Serie();
        $form = $this->createForm(new SerieType(), $entity);

        return $this->render('BDThequeDataModelBundle:Serie:new.html.twig', array(
                    'entity' => $entity,
                    'form' => $form->createView(),
                ));
    }

    /**
     * Creates a new Serie entity.
     *
     */
    public function createAction(Request $request) {
        $entity = new Serie();
        $form = $this->createForm(new SerieType(), $entity);
        $form->bind($request);

        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($entity);
            $em->flush();

            return $this->redirect($this->generateUrl('serie_show', array('id' => $entity->getId())));
        }

        return $this->render('BDThequeDataModelBundle:Serie:new.html.twig', array(
                    'entity' => $entity,
                    'form' => $form->createView(),
                ));
    }

    /**
     * Displays a form to edit an existing Serie entity.
     *
     */
    public function editAction($id) {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Serie')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Serie entity.');
        }

        $editForm = $this->createForm(new SerieType(), $entity);
        $deleteForm = $this->createDeleteForm($id);

        return $this->render('BDThequeDataModelBundle:Serie:edit.html.twig', array(
                    'entity' => $entity,
                    'edit_form' => $editForm->createView(),
                    'delete_form' => $deleteForm->createView(),
                ));
    }

    /**
     * Edits an existing Serie entity.
     *
     */
    public function updateAction(Request $request, $id) {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Serie')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Serie entity.');
        }

        $deleteForm = $this->createDeleteForm($id);
        $editForm = $this->createForm(new SerieType(), $entity);
        $editForm->bind($request);

        if ($editForm->isValid()) {
            $em->persist($entity);
            $em->flush();

            return $this->redirect($this->generateUrl('serie_edit', array('id' => $id)));
        }

        return $this->render('BDThequeDataModelBundle:Serie:edit.html.twig', array(
                    'entity' => $entity,
                    'edit_form' => $editForm->createView(),
                    'delete_form' => $deleteForm->createView(),
                ));
    }

    /**
     * Deletes a Serie entity.
     *
     */
    public function deleteAction(Request $request, $id) {
        $form = $this->createDeleteForm($id);
        $form->bind($request);

        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $entity = $em->getRepository('BDThequeDataModelBundle:Serie')->find($id);

            if (!$entity) {
                throw $this->createNotFoundException('Unable to find Serie entity.');
            }

            $em->remove($entity);
            $em->flush();
        }

        return $this->redirect($this->generateUrl('serie'));
    }

    private function createDeleteForm($id) {
        return $this->createFormBuilder(array('id' => $id))
                        ->add('id', 'hidden')
                        ->getForm()
        ;
    }

}
