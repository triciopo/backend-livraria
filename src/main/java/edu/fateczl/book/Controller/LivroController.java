package edu.fateczl.book.Controller;

import edu.fateczl.book.DTO.UpdateLivroDTO;
import edu.fateczl.book.Models.Livro;
import edu.fateczl.book.Repository.LivroRepository;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;

@RestController
@RequestMapping("/livro")

public class LivroController {

    private final LivroRepository livroRepository;
    private final ModelMapper modelMapper;

    public LivroController(LivroRepository livroRepository, ModelMapper modelMapper) {
        this.livroRepository = livroRepository;
        this.modelMapper = modelMapper;
    }

    @GetMapping
    public @ResponseBody Iterable<Livro> getAllLivros(@RequestParam(required = false) String titulo) {
        if (titulo == null || titulo.isBlank())
            return livroRepository.findAll();

        return livroRepository.getAllByTituloContainsIgnoreCase(titulo);
    }

    @GetMapping(path="/{id}")
    public @ResponseBody Optional<Livro> getLivroById(@PathVariable Long id) {
        return livroRepository.findById(id);
    }

    @PostMapping
    public @ResponseBody Livro createLivro(@RequestBody Livro livro){
        return livroRepository.save(livro);
    }

    @PutMapping(path="/{id}")
    public @ResponseBody Livro updateLivro(@PathVariable Long id, @RequestBody UpdateLivroDTO dto){
        var livro = livroRepository.getById(id);

        if (livro == null)
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Livro não existe!");

        Livro novoLivro  = modelMapper.map(dto, Livro.class);
        novoLivro.setId(id);

        return livroRepository.save(novoLivro);
    }

    @DeleteMapping(path="/{id}")
    public @ResponseBody Boolean deleteLivro(@PathVariable Long id){
        livroRepository.deleteById(id);
        return true;
    }
}
