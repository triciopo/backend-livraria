package edu.fateczl.book.Repository;

import edu.fateczl.book.Models.Categoria;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.CrudRepository;

public interface CategoriaRepository extends CrudRepository<Categoria, Long> {
    Iterable<Categoria> getAllByNome(String nome);

    Object getById(Long id);

    Iterable<Categoria> getAllByNomeContainsIgnoreCase(String nome);

    @Procedure(procedureName = "atualizar_preco_categoria")
    void atualizarPrecoCategoria(Long categoriaId, Double percentual);
}
