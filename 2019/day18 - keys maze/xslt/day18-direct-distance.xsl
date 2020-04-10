<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <distances>
            <xsl:apply-templates select="//cell[not(text()='#')]" mode="beginning"/>
        </distances>
    </xsl:template>

    <xsl:template match="cell" mode="beginning">
        <xsl:variable name="line" select="parent::line/count(preceding-sibling::line) +1" as="xs:integer"/>
        <xsl:variable name="column" select="count(preceding-sibling::cell) +1" as="xs:integer"/>
        <xsl:variable name="walls-around" select="(if (preceding-sibling::cell[1] = '#') then 1 else 0) 
            + (if (following-sibling::cell[1] = '#') then 1 else 0)
            + (if (parent::line/preceding-sibling::line[1]/cell[$column] = '#') then 1 else 0)
            + (if (parent::line/following-sibling::line[1]/cell[$column] = '#') then 1 else 0)" as="xs:integer"/>
        
        <!-- On définit comme points de départ : 
        - clefs et portes
        - intersections (points simples d'où l'on peut partir dans au moins 3 directions -->
        <!-- Depuis chaque point de départ, on part dans toutes les directions qui ne sont pas directement des murs -->
        <xsl:if test="text() != '.' or $walls-around &lt; 2">
            <cell line="{$line}" column="{$column}" text="{text()}">
                <xsl:if test="preceding-sibling::cell[1] != '#'">
                    <xsl:apply-templates select="preceding-sibling::cell[1]" mode="distance">
                        <xsl:with-param name="distance" select="1"/>
                        <xsl:with-param name="direction" select="'left'"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:if test="following-sibling::cell[1] != '#'">
                    <xsl:apply-templates select="following-sibling::cell[1]" mode="distance">
                        <xsl:with-param name="distance" select="1"/>
                        <xsl:with-param name="direction" select="'right'"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:if test="parent::line/preceding-sibling::line[1]/cell[$column] != '#'">
                    <xsl:apply-templates select="parent::line/preceding-sibling::line[1]/cell[$column]" mode="distance">
                        <xsl:with-param name="distance" select="1"/>
                        <xsl:with-param name="direction" select="'up'"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:if test="parent::line/following-sibling::line[1]/cell[$column] != '#'">
                    <xsl:apply-templates select="parent::line/following-sibling::line[1]/cell[$column]" mode="distance">
                        <xsl:with-param name="distance" select="1"/>
                        <xsl:with-param name="direction" select="'down'"/>
                    </xsl:apply-templates>
                </xsl:if>
            </cell>
        </xsl:if>
    </xsl:template>

    <!-- On calcule la distance de chacun des chemins de manière récursive -->
    <!-- Chaque chemin est calculé 2 fois : de A vers B et de B vers A -->
    <xsl:template match="cell" mode="distance">
        <xsl:param name="distance"/>
        <xsl:param name="direction"/>
        
        <xsl:variable name="line" select="parent::line/count(preceding-sibling::line) +1" as="xs:integer"/>
        <xsl:variable name="column" select="count(preceding-sibling::cell) +1" as="xs:integer"/>
        <xsl:variable name="walls-around" select="(if (preceding-sibling::cell[1] = '#') then 1 else 0) 
            + (if (following-sibling::cell[1] = '#') then 1 else 0)
            + (if (parent::line/preceding-sibling::line[1]/cell[$column] = '#') then 1 else 0)
            + (if (parent::line/following-sibling::line[1]/cell[$column] = '#') then 1 else 0)"/>
        
        <xsl:choose>
            <!-- si on est sur une case de passage simple, on repart dans la direction qui n'est pas celle depuis laquelle on arrivait ; on rajoute 1 à la distance -->
            <xsl:when test="$walls-around = 2 and text() = '.'">
                <xsl:if test="preceding-sibling::cell[1] != '#' and $direction != 'right'">
                    <xsl:apply-templates select="preceding-sibling::cell[1]" mode="distance">
                        <xsl:with-param name="distance" select="$distance + 1"/>
                        <xsl:with-param name="direction" select="'left'"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:if test="following-sibling::cell[1] != '#' and $direction != 'left'">
                    <xsl:apply-templates select="following-sibling::cell[1]" mode="distance">
                        <xsl:with-param name="distance" select="$distance + 1"/>
                        <xsl:with-param name="direction" select="'right'"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:if test="parent::line/preceding-sibling::line[1]/cell[$column] != '#' and $direction != 'down'">
                    <xsl:apply-templates select="parent::line/preceding-sibling::line[1]/cell[$column]" mode="distance">
                        <xsl:with-param name="distance" select="$distance + 1"/>
                        <xsl:with-param name="direction" select="'up'"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:if test="parent::line/following-sibling::line[1]/cell[$column] != '#' and $direction != 'up'">
                    <xsl:apply-templates select="parent::line/following-sibling::line[1]/cell[$column]" mode="distance">
                        <xsl:with-param name="distance" select="$distance + 1"/>
                        <xsl:with-param name="direction" select="'down'"/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:when>
            <!-- Si on est sur une intersection, une clef ou une porte, on écrit le point d'arrivée et la distance -->
            <xsl:otherwise>
                <cell line="{$line}" column="{$column}" text="{text()}" distance="{$distance}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>