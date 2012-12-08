<?php

namespace BDTheque\DataModelBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Response;

class InitialeController extends Controller {

    /**
     * @param string $class
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function listAction($class) {
        $manager = $this->get('bdtheque_datamodel.' . strtolower($class) . '_manager');
        $entities = $manager->getRepository()->getInitiales();


        return new Response("classname $class: " . json_encode($entities));
    }

    /**
     * @param string $class
     * @param string $initiale
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function detailAction($class, $initiale) {
        $manager = $this->get('bdtheque_datamodel.' . strtolower($class) . '_manager');
        $entities = $manager->getRepository()->getByInitiales($initiale);


        return new Response("classname $class: " . json_encode($entities));
    }

}