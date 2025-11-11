package edu.fateczl.book.Repository;

import edu.fateczl.book.Models.Autor;
import org.springframework.data.repository.CrudRepository;

public interface AutorRepository extends CrudRepository<Autor, Long> {
    Iterable<Autor> getAllByNome(String nome);

    Object getById(Long id);
}
