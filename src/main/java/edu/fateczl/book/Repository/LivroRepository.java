package edu.fateczl.book.Repository;

import edu.fateczl.book.Models.Livro;
import org.springframework.data.repository.CrudRepository;

public interface LivroRepository extends CrudRepository<Livro, Long> {
    Iterable<Livro> getAllByTitulo(String titulo);

    Object getById(Long id);
}
