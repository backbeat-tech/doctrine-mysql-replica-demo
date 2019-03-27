<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
use App\Entity\Item;
use Symfony\Component\HttpFoundation\Response;
use Doctrine\ORM\EntityManagerInterface;
use App\Repository\ItemRepository;

class AppController extends AbstractController
{
    /**
     * @Route("/")
     */
    public function read(ItemRepository $repo)
    {
        return $this->json($repo->findBy([]));
    }

    /**
     * @Route("/insert")
     */
    public function insert(EntityManagerInterface $em)
    {
        $item = new Item();
        $item->setLevel(rand(1, 10000));
        $em->persist($item);
        $em->flush();

        return $this->json($item, Response::HTTP_CREATED);
    }

    /**
     * @Route("/update/{id}")
     */
    public function update(int $id, ItemRepository $repo, EntityManagerInterface $em)
    {
        $item = $repo->find($id);
        $item->setLevel(rand(1, 10000));
        $em->persist($item);
        $em->flush();

        return $this->json($item);
    }

    /**
     * @Route("/ping")
     */
    public function ping(ItemRepository $repo)
    {
        return new Response('pong');
    }
}
