<?php

namespace BDTheque\DataModelBundle\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;

use BDTheque\DataModelBundle\Entity\Collection;
use BDTheque\DataModelBundle\Form\CollectionType;

/**
 * Collection controller.
 *
 */
class CollectionController extends Controller
{
    /**
     * Lists all Collection entities.
     *
     */
    public function indexAction()
    {
        $em = $this->getDoctrine()->getManager();

        $entities = $em->getRepository('BDThequeDataModelBundle:Collection')->findAll();

        return $this->render('BDThequeDataModelBundle:Collection:index.html.twig', array(
            'entities' => $entities,
        ));
    }

    /**
     * Finds and displays a Collection entity.
     *
     */
    public function showAction($id)
    {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Collection')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Collection entity.');
        }

        $deleteForm = $this->createDeleteForm($id);

        return $this->render('BDThequeDataModelBundle:Collection:show.html.twig', array(
            'entity'      => $entity,
            'delete_form' => $deleteForm->createView(),        ));
    }

    /**
     * Displays a form to create a new Collection entity.
     *
     */
    public function newAction()
    {
        $entity = new Collection();
        $form   = $this->createForm(new CollectionType(), $entity);

        return $this->render('BDThequeDataModelBundle:Collection:new.html.twig', array(
            'entity' => $entity,
            'form'   => $form->createView(),
        ));
    }

    /**
     * Creates a new Collection entity.
     *
     */
    public function createAction(Request $request)
    {
        $entity  = new Collection();
        $form = $this->createForm(new CollectionType(), $entity);
        $form->bind($request);

        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($entity);
            $em->flush();

            return $this->redirect($this->generateUrl('collection_show', array('id' => $entity->getId())));
        }

        return $this->render('BDThequeDataModelBundle:Collection:new.html.twig', array(
            'entity' => $entity,
            'form'   => $form->createView(),
        ));
    }

    /**
     * Displays a form to edit an existing Collection entity.
     *
     */
    public function editAction($id)
    {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Collection')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Collection entity.');
        }

        $editForm = $this->createForm(new CollectionType(), $entity);
        $deleteForm = $this->createDeleteForm($id);

        return $this->render('BDThequeDataModelBundle:Collection:edit.html.twig', array(
            'entity'      => $entity,
            'edit_form'   => $editForm->createView(),
            'delete_form' => $deleteForm->createView(),
        ));
    }

    /**
     * Edits an existing Collection entity.
     *
     */
    public function updateAction(Request $request, $id)
    {
        $em = $this->getDoctrine()->getManager();

        $entity = $em->getRepository('BDThequeDataModelBundle:Collection')->find($id);

        if (!$entity) {
            throw $this->createNotFoundException('Unable to find Collection entity.');
        }

        $deleteForm = $this->createDeleteForm($id);
        $editForm = $this->createForm(new CollectionType(), $entity);
        $editForm->bind($request);

        if ($editForm->isValid()) {
            $em->persist($entity);
            $em->flush();

            return $this->redirect($this->generateUrl('collection_edit', array('id' => $id)));
        }

        return $this->render('BDThequeDataModelBundle:Collection:edit.html.twig', array(
            'entity'      => $entity,
            'edit_form'   => $editForm->createView(),
            'delete_form' => $deleteForm->createView(),
        ));
    }

    /**
     * Deletes a Collection entity.
     *
     */
    public function deleteAction(Request $request, $id)
    {
        $form = $this->createDeleteForm($id);
        $form->bind($request);

        if ($form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $entity = $em->getRepository('BDThequeDataModelBundle:Collection')->find($id);

            if (!$entity) {
                throw $this->createNotFoundException('Unable to find Collection entity.');
            }

            $em->remove($entity);
            $em->flush();
        }

        return $this->redirect($this->generateUrl('collection'));
    }

    private function createDeleteForm($id)
    {
        return $this->createFormBuilder(array('id' => $id))
            ->add('id', 'hidden')
            ->getForm()
        ;
    }
}
