package edu.fateczl.book.Controller;

import edu.fateczl.book.DTO.UpdateCategoriaDTO;
import edu.fateczl.book.Models.Categoria;
import edu.fateczl.book.Repository.CategoriaRepository;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;

@RestController
@RequestMapping("/categoria")
public class CategoriaController {

    private final CategoriaRepository categoriaRepository;
    private final ModelMapper modelMapper;

    public CategoriaController(CategoriaRepository categoriaRepository, ModelMapper modelMapper) {
        this.categoriaRepository = categoriaRepository;
        this.modelMapper = modelMapper;
    }

    @GetMapping
    public @ResponseBody Iterable<Categoria> getAllCategorias(@RequestParam(required = false) String nome) {
        if (nome == null || nome.isBlank())
            return categoriaRepository.findAll();

        return categoriaRepository.getAllByNomeContainsIgnoreCase(nome);
    }

    @GetMapping(path="{id}")
    public @ResponseBody Optional<Categoria> getCategoriaById(@PathVariable Long id) {
        return categoriaRepository.findById(id);
    }

    @PostMapping
    public @ResponseBody Categoria createCategoria(@RequestBody Categoria categoria){
        return categoriaRepository.save(categoria);
    }

    @PutMapping("/{id}")
    public @ResponseBody Categoria updateCategoria(@PathVariable Long id, @RequestBody UpdateCategoriaDTO dto) {
        var categoria = categoriaRepository.getById(id);

        if (categoria == null)
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Categoria não existe!");

        Categoria novaCategoria = modelMapper.map(dto, Categoria.class);
        novaCategoria.setId(id);

        return categoriaRepository.save(novaCategoria);
    }

    @DeleteMapping(path="/{id}")
    public @ResponseBody Boolean deleteCategoria(@PathVariable Long id){
        categoriaRepository.deleteById(id);
        return true;
    }

    @GetMapping(path="/atualizarpreco")
    public @ResponseBody Boolean AtualizarPrecoCategoria(@RequestParam Long categoriaId, @RequestParam Double percentual) {
        categoriaRepository.atualizarPrecoCategoria(categoriaId, percentual);
        return true;
    }
}

