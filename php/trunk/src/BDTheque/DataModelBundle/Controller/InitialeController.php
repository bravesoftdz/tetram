<?php

namespace BDTheque\DataModelBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Response;

class InitialeController extends Controller {

    /**
     * @param string $class
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function listAction($class, $_format) {
        $manager = $this->get('bdtheque_datamodel.' . strtolower($class) . '_manager');
        $entities = $manager->getRepository()->getInitiales();

        switch ($_format) {
            case 'json':
                return new Response(json_encode($entities));
                break;
            default:
                return $this->render('BDThequeDataModelBundle:Initiale:list.html.twig', array(
                            'initiales' => $entities,
                            'class' => strtolower($class),
                        ));
        }
    }

    /**
     * @param string $class
     * @param string $initiale
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function detailAction($class, $initiale, $_format) {
        $manager = $this->get('bdtheque_datamodel.' . strtolower($class) . '_manager');
        $entities = $manager->getRepository()->getByInitiales($initiale);

        switch ($_format) {
            case 'json':
                return new Response(json_encode($entities));
                break;
            default:
                return $this->render('BDThequeDataModelBundle:Initiale:detail.html.twig', array(
                            'items' => $entities,
                            'class' => strtolower($class),
                            'initiale' => $initiale,
                        ));
        }
    }

}

?>