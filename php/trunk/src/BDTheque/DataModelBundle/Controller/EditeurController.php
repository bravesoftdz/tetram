<?php

namespace BDTheque\DataModelBundle\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;

use BDTheque\DataModelBundle\Entity\Editeur;
use BDTheque\DataModelBundle\Form\EditeurType;

/**
 * Editeur controller.
 *
 */
class EditeurController extends Controller
{
    /**
     * Lists all Editeur entities.
     *
     */
    public function indexAction()
    {
        $em = $this->getDoctrine()->getManager();

        $entities = $em->getRepository('BDThequeDataModelBundle:Editeur')->findAll();

        return $this->render('BDThequeDataModelBundle:Editeur:index.html.twig', array(
            'entities' => $entities,
        ));
    }

    /**
     * Finds and displays a Editeur entity.
     *
     */
    public function showAction($id)
    {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Editeur')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Editeur entity.');
        }

        $deleteForm = $this->createDeleteForm($id);

        return $this->render('BDThequeDataModelBundle:Editeur:show.html.twig', array(
            'entity'      => $entity,
            'delete_form' => $deleteForm->createView(),        ));
    }

    /**
     * Displays a form to create a new Editeur entity.
     *
     */
    public function newAction()
    {
        $entity = new Editeur();
        $form   = $this->createForm(new EditeurType(), $entity);

        return $this->render('BDThequeDataModelBundle:Editeur:new.html.twig', array(
            'entity' => $entity,
            'form'   => $form->createView(),
        ));
    }

    /**
     * Creates a new Editeur entity.
     *
     */
    public function createAction(Request $request)
    {
        $entity  = new Editeur();
        $form = $this->createForm(new EditeurType(), $entity);
        $form->bind($request);

        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($entity);
            $em->flush();

            return $this->redirect($this->generateUrl('editeur_show', array('id' => $entity->getId())));
        }

        return $this->render('BDThequeDataModelBundle:Editeur:new.html.twig', array(
            'entity' => $entity,
            'form'   => $form->createView(),
        ));
    }

    /**
     * Displays a form to edit an existing Editeur entity.
     *
     */
    public function editAction($id)
    {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Editeur')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Editeur entity.');
        }

        $editForm = $this->createForm(new EditeurType(), $entity);
        $deleteForm = $this->createDeleteForm($id);

        return $this->render('BDThequeDataModelBundle:Editeur:edit.html.twig', array(
            'entity'      => $entity,
            'edit_form'   => $editForm->createView(),
            'delete_form' => $deleteForm->createView(),
        ));
    }

    /**
     * Edits an existing Editeur entity.
     *
     */
    public function updateAction(Request $request, $id)
    {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Editeur')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Editeur entity.');
        }

        $deleteForm = $this->createDeleteForm($id);
        $editForm = $this->createForm(new EditeurType(), $entity);
        $editForm->bind($request);

        if ($editForm->isValid()) {
            $em->persist($entity);
            $em->flush();

            return $this->redirect($this->generateUrl('editeur_edit', array('id' => $id)));
        }

        return $this->render('BDThequeDataModelBundle:Editeur:edit.html.twig', array(
            'entity'      => $entity,
            'edit_form'   => $editForm->createView(),
            'delete_form' => $deleteForm->createView(),
        ));
    }

    /**
     * Deletes a Editeur entity.
     *
     */
    public function deleteAction(Request $request, $id)
    {
        $form = $this->createDeleteForm($id);
        $form->bind($request);

        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $entity = $em->getRepository('BDThequeDataModelBundle:Editeur')->find($id);

            if (!$entity) {
                throw $this->createNotFoundException('Unable to find Editeur entity.');
            }

            $em->remove($entity);
            $em->flush();
        }

        return $this->redirect($this->generateUrl('editeur'));
    }

    private function createDeleteForm($id)
    {
        return $this->createFormBuilder(array('id' => $id))
            ->add('id', 'hidden')
            ->getForm()
        ;
    }
}
